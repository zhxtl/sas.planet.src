unit t_TileStorageSQLite;

interface

uses
  Types,
  i_BinaryData,
  i_TileInfoBasic,
  i_MapVersionInfo,
  i_ContentTypeInfo,
  u_TileRectInfoShort; // for TArrayOfTileInfoShortInternal

type
  TGetTileInfoItem = (
    gtiiLoadDate,
    gtiiSize,
    gtiiBody,
    gtiiContentType
  );
  TGetTileInfoModeSQLite = set of TGetTileInfoItem;

  TDeleteTileFlag =(
    dtfOnlyIfSameAsPrevVersion
  );
  TDeleteTileFlags = set of TDeleteTileFlag;

  TDeleteTileAllData = record
    DXY: TPoint;
    DZoom: Byte;
    DVersionInfo: IMapVersionInfo;
    DDeleteTileFlags: TDeleteTileFlags;
    DPrevSizeValue: Integer;
  end;
  PDeleteTileAllData = ^TDeleteTileAllData;

  TSaveTileFlag = (
    stfKeepExisting,
    stfSkipIfSameAsPrev
  );
  TSaveTileFlags = set of TSaveTileFlag;

  TSaveTileAllData = record
    SXY: TPoint;
    SZoom: Byte;
    SVersionInfo: IMapVersionInfo;
    SLoadDate: TDateTime;
    SContentType: IContentTypeInfoBasic;
    SData: IBinaryData;
    SSaveTileFlags: TSaveTileFlags;
  end;
  PSaveTileAllData = ^TSaveTileAllData;

  TReplaceVersionFlag = (
    rvfOverwriteExisting
  );
  TReplaceVersionFlags = set of TReplaceVersionFlag;

  TSetTileVersionAllData = record
    SXY: TPoint;
    SZoom: Byte;
    SVersionSrc: IMapVersionInfo;
    SVersionDst: IMapVersionInfo;
    SReplaceVersionFlags: TReplaceVersionFlags;
  end;
  PSetTileVersionAllData = ^TSetTileVersionAllData;

  TGetTileInfo = record
    GTilePos: TPoint;
    GZoom: Byte;
    GVersion: IMapVersionInfo;
    GShowPrevVersion: Boolean;
    GMode: TGetTileInfoModeSQLite;
  end;
  PGetTileInfo = ^TGetTileInfo;

  TTileInfoShortEnumData = record
    DestRect: TRect;
    DestZoom: Byte;
    RectVersionInfo: IMapVersionInfo;
    RectCount: TPoint;
    RectItems: TArrayOfTileInfoShortInternal;
  end;
  PTileInfoShortEnumData = ^TTileInfoShortEnumData;

  TGetTileResult = record
    // ���������
    GTileInfo: ITileInfoBasic;
    // �������������� ���������, ������� ���������, �� ������� �������� �� �������������
    GExtraMode: TGetTileInfoModeSQLite;
  end;
  PGetTileResult = ^TGetTileResult;

implementation

end.