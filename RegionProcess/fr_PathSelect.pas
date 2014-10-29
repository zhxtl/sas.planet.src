{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit fr_PathSelect;

interface

uses
  Classes,
  Controls,
  StdCtrls,
  SysUtils,
  FileCtrl,
  ExtCtrls,                     
  i_LanguageManager,
  i_PathConfig,
  u_CommonFormAndFrameParents;

type
  TfrPathSelect = class(TFrame)
    BtnDef: TButton;
    BtnSelectPath: TButton;
    LCaption: TLabel;
    EPath: TEdit;
    pnlPath: TPanel;
    pnlmain: TPanel;
    pnlCaption: TPanel;
    pnlButtnos: TPanel;
    procedure BtnSelectPathClick(Sender: TObject);
    procedure BtnDefClick(Sender: TObject);
  private
    FPathConfig: IPathConfig;
    FCaption: string;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const ACaption: string;
      const APathConfig: IPathConfig
    ); reintroduce;
    function GetPath: string;
    procedure Show(AParent: TWinControl);
  end;

implementation

{$R *.dfm}
uses
  gnugettext;

{ TfrPathSelect }

constructor TfrPathSelect.Create(
  const ALanguageManager: ILanguageManager;
  const ACaption: string;
  const APathConfig: IPathConfig
);
begin
  inherited Create(ALanguageManager);
  FCaption := ACaption;
  FPathConfig := APathConfig;
  EPath.Text := IncludeTrailingPathDelimiter(FPathConfig.path);
end;

procedure TfrPathSelect.BtnDefClick(Sender: TObject);
begin
  EPath.Text := IncludeTrailingPathDelimiter(FPathConfig.DefaultPath);
end;

procedure TfrPathSelect.BtnSelectPathClick(Sender: TObject);
var
  TempPath: string;
begin
  TempPath := FPathConfig.FullPath;
  if SelectDirectory(_(FCaption), '', TempPath) then begin
    EPath.Text := StringReplace(IncludeTrailingPathDelimiter(TempPath), FPathConfig.BasePathConfig.Path, '.\', [rfIgnoreCase]);
  end;
end;

function TfrPathSelect.GetPath: string;
begin
  Result := IncludeTrailingPathDelimiter(EPath.Text);
end;

procedure TfrPathSelect.Show(AParent: TWinControl);
begin
  Parent := AParent;
  LCaption.Caption := _(FCaption);
end;

end.