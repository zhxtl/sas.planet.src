{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit frm_GoTo;

interface

uses
  Windows,
  SysUtils,
  Forms,
  Classes,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Controls,
  t_GeoTypes,
  i_LanguageManager,
  i_MarksDb,
  i_MainGeoCoderConfig,
  i_ViewPortState,
  i_ValueToStringConverter,
  i_GeoCoder,
  i_LocalCoordConverter,
  u_CommonFormAndFrameParents,
  fr_LonLat;

type

  TfrmGoTo = class(TFormWitghLanguageManager)
    lblZoom: TLabel;
    btnGoTo: TButton;
    cbbZoom: TComboBox;
    btnCancel: TButton;
    pnlBottomButtons: TPanel;
    cbbGeoCode: TComboBox;
    pgcSearchType: TPageControl;
    tsPlaceMarks: TTabSheet;
    tsSearch: TTabSheet;
    tsCoordinates: TTabSheet;
    cbbAllMarks: TComboBox;
    cbbSearcherType: TComboBox;
    procedure btnGoToClick(Sender: TObject);
    procedure cbbAllMarksDropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMarksDb: IMarksDb;
    FMainGeoCoderConfig: IMainGeoCoderConfig;
    FViewPortState: IViewPortState;
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    FResult: IGeoCodeResult;
    frLonLatPoint: TfrLonLat;
    FMarksList: IInterfaceList;
    function GeocodeResultFromLonLat(
      const ASearch: WideString;
      const ALonLat: TDoublePoint;
      const AMessage: WideString
    ): IGeoCodeResult;
    procedure InitHistory;
    procedure InitGeoCoders;
    procedure EmptyGeoCoders;
    procedure MarksListToStrings(AList: IInterfaceList; AStrings: TStrings);
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMarksDb: IMarksDb;
      const AMainGeoCoderConfig: IMainGeoCoderConfig;
      const AViewPortState: IViewPortState;
      const AValueToStringConverterConfig: IValueToStringConverterConfig
    ); reintroduce;
    destructor Destroy; override;
    function ShowGeocodeModal(
      out AResult: IGeoCodeResult;
      out AZoom: Byte
    ): Boolean;
  end;

implementation

uses
  ActiveX,
  i_GeoCoderList,
  i_MarksSimple,
  i_OperationNotifier,
  u_OperationNotifier,
  u_GeoCodeResult,
  u_GeoCodePlacemark;

{$R *.dfm}

function TfrmGoTo.GeocodeResultFromLonLat(
  const ASearch: WideString;
  const ALonLat: TDoublePoint;
  const AMessage: WideString
): IGeoCodeResult;
var
  VPlace: IGeoCodePlacemark;
  VList: IInterfaceList;
begin
  VPlace := TGeoCodePlacemark.Create(ALonLat, AMessage, '', '', 4);
  VList := TInterfaceList.Create;
  VList.Add(VPlace);
  Result := TGeoCodeResult.Create(ASearch, 203, '', VList);
end;

procedure TfrmGoTo.InitGeoCoders;
var
  VEnum: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
  VItem: IGeoCoderListEntity;
  VIndex: Integer;
  VActiveGUID: TGUID;
  VActiveIndex: Integer;
begin
  VEnum := FMainGeoCoderConfig.GetList.GetGUIDEnum;
  VActiveGUID := FMainGeoCoderConfig.ActiveGeoCoderGUID;
  VActiveIndex := -1;
  while VEnum.Next(1, VGUID, i) = S_OK do begin
    VItem := FMainGeoCoderConfig.GetList.Get(VGUID);
    VItem._AddRef;
    VIndex := cbbSearcherType.Items.AddObject(VItem.GetCaption, Pointer(VItem));
    if IsEqualGUID(VGUID, VActiveGUID) then begin
      VActiveIndex := VIndex;
    end;
  end;
  if VActiveIndex < 0 then begin
    VActiveIndex := 0;
  end;
  cbbSearcherType.ItemIndex := VActiveIndex;
end;

procedure TfrmGoTo.InitHistory;
var
  i: Integer;
begin
  FMainGeoCoderConfig.SearchHistory.LockRead;
  try
    for i := 0 to FMainGeoCoderConfig.SearchHistory.Count - 1 do begin
      cbbGeoCode.Items.Add(FMainGeoCoderConfig.SearchHistory.GetItem(i));
    end;
  finally
    FMainGeoCoderConfig.SearchHistory.UnlockRead;
  end;
end;

procedure TfrmGoTo.MarksListToStrings(AList: IInterfaceList;
  AStrings: TStrings);
var
  i: Integer;
  VMarkId: IMarkId;
begin
  AStrings.Clear;
  for i := 0 to AList.Count - 1 do begin
    VMarkId := IMarkId(AList[i]);
    AStrings.AddObject(VMarkId.name, Pointer(VMarkId));
  end;
end;

procedure TfrmGoTo.btnGoToClick(Sender: TObject);
var
  textsrch:String;
  VIndex: Integer;
  VMarkId: IMarkID;
  VMark: IMark;
  VLonLat: TDoublePoint;
  VGeoCoderItem: IGeoCoderListEntity;
  VLocalConverter: ILocalCoordConverter;
  VNotifier: INotifierOperation;
begin
  VLocalConverter := FViewPortState.GetVisualCoordConverter;
  if pgcSearchType.ActivePage = tsPlaceMarks then begin
    VIndex := cbbAllMarks.ItemIndex;
    if VIndex >= 0 then begin
      VMarkId := IMarkId(Pointer(cbbAllMarks.Items.Objects[VIndex]));
      VMark := FMarksDb.GetMarkByID(VMarkId);
      VLonLat := VMark.GetGoToLonLat;
      FResult := GeocodeResultFromLonLat(cbbAllMarks.Text, VLonLat, VMark.name);
      ModalResult := mrOk;
    end else begin
      ModalResult := mrCancel;
    end;
  end else if pgcSearchType.ActivePage = tsCoordinates then begin
    VLonLat := frLonLatPoint.LonLat;
    textsrch := FValueToStringConverterConfig.GetStatic.LonLatConvert(VLonLat);
    FResult := GeocodeResultFromLonLat(textsrch, VLonLat, textsrch);
    ModalResult := mrOk;
  end else if pgcSearchType.ActivePage = tsSearch then begin
    textsrch:= Trim(cbbGeoCode.Text);
    VGeoCoderItem := nil;
    VIndex := cbbSearcherType.ItemIndex;
    if VIndex >= 0 then begin
      VGeoCoderItem := IGeoCoderListEntity(Pointer(cbbSearcherType.Items.Objects[VIndex]));
    end;
    if VGeoCoderItem <> nil then begin
      VNotifier := TOperationNotifier.Create;
      FResult := VGeoCoderItem.GetGeoCoder.GetLocations(VNotifier, VNotifier.CurrentOperation, textsrch, VLocalConverter);
      FMainGeoCoderConfig.SearchHistory.AddItem(textsrch);
      FMainGeoCoderConfig.ActiveGeoCoderGUID := VGeoCoderItem.GetGUID;
      ModalResult := mrOk;
    end else begin
      ModalResult := mrCancel;
    end;
  end;
end;

function TfrmGoTo.ShowGeocodeModal(
  out AResult: IGeoCodeResult;
  out AZoom: Byte
): Boolean;
var
  VLocalConverter: ILocalCoordConverter;
begin
   frLonLatPoint.Parent := tsCoordinates;
  VLocalConverter := FViewPortState.GetVisualCoordConverter;
  AZoom := VLocalConverter.GetZoom;
  cbbZoom.ItemIndex := Azoom;
  frLonLatPoint.LonLat := VLocalConverter.GetCenterLonLat;
  InitGeoCoders;
  InitHistory;
  try
    if ShowModal = mrOk then begin
      Result := true;
      AResult := FResult;
      AZoom := cbbZoom.ItemIndex;
    end else begin
      Result := False;
      AResult := nil;
      AZoom := 0;
    end;
  finally
    EmptyGeoCoders;
  end;
  cbbAllMarks.Clear;
  FMarksList:=nil;
  cbbGeoCode.Clear;
end;

procedure TfrmGoTo.cbbAllMarksDropDown(Sender: TObject);
begin
  if cbbAllMarks.Items.Count=0 then begin
    FMarksList := FMarksDb.GetAllMarskIdList;
    MarksListToStrings(FMarksList, cbbAllMarks.Items);
  end;
end;

constructor TfrmGoTo.Create(
  const ALanguageManager: ILanguageManager;
  const AMarksDb: IMarksDb;
  const AMainGeoCoderConfig: IMainGeoCoderConfig;
  const AViewPortState: IViewPortState;
  const AValueToStringConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create(ALanguageManager);
  FMarksDb := AMarksDb;
  FMainGeoCoderConfig := AMainGeoCoderConfig;
  FViewPortState := AViewPortState;
  FValueToStringConverterConfig := AValueToStringConverterConfig;
  frLonLatPoint := TfrLonLat.Create(ALanguageManager, FViewPortState, FValueToStringConverterConfig, tssCenter);
  frLonLatPoint.Width:= tsCoordinates.Width;
  frLonLatPoint.Height:= tsCoordinates.Height;
end;

destructor TfrmGoTo.Destroy;
begin
  FreeAndNil(frLonLatPoint);
  inherited;
end;

procedure TfrmGoTo.EmptyGeoCoders;
var
  VObj: IInterface;
  i: Integer;
begin
  for i := 0 to cbbSearcherType.Items.Count - 1 do begin
    VObj := IInterface(Pointer(cbbSearcherType.Items.Objects[i]));
    VObj._Release;
  end;
  cbbSearcherType.Clear;
end;

procedure TfrmGoTo.FormShow(Sender: TObject);
begin
  if pgcSearchType.ActivePage = tsPlaceMarks then begin
    cbbAllMarks.SetFocus;
  end else if pgcSearchType.ActivePage = tsCoordinates then begin
    frLonLatPoint.SetFocus;
  end else if pgcSearchType.ActivePage = tsSearch then begin
    cbbGeoCode.SetFocus;
  end;
end;

end.
