unit u_VectorDataItemBase;

interface

uses
  t_GeoTypes,
  i_VectorDataItemSimple;

type
  TVectorDataItemBase = class(TInterfacedObject, IVectorDataItemSimple)
  private
    FName: string;
    FDesc: string;
  protected
    function GetName: string;
    function GetDesc: string;
    function GetLLRect: TDoubleRect;  virtual; abstract;
    function GetPoints: TArrayOfDoublePoint;  virtual; abstract;
    function GetHintText: string;
    function GetInfoCaption: string;
    function GetInfoHTML: string;

    function IsPoint: Boolean; virtual; abstract;
    function IsLine: Boolean; virtual; abstract;
    function IsPoly: Boolean; virtual; abstract;
  public
    constructor Create(
      AName: string;
      ADesc: string
    );
  end;

implementation

uses
  SysUtils,
  StrUtils;

{ TVectorDataItemBase }

constructor TVectorDataItemBase.Create(AName, ADesc: string);
begin
  FName := AName;
  FDesc := ADesc;
end;

function TVectorDataItemBase.GetDesc: string;
begin
  Result := FDesc;
end;

function HTML2Txt(OrigHTML: String): String;
var
  NoHTML: String;
function MidStr(const pString, pAbre, pFecha: String; pInclui: boolean): string;
var
  lIni, lFim : integer;
begin
  if (pInclui = False) then begin
    lIni := System.Pos(UpperCase(pAbre), UpperCase(pString)) + Length(pAbre);
    lFim := PosEx(UpperCase(pFecha),UpperCase(pString),lIni)+1;
  end else begin
    lIni := System.Pos(UpperCase(pAbre), UpperCase(pString));
    lFim := PosEx(UpperCase(pFecha),UpperCase(pString),lIni + Length(pAbre))+1;
  end;
  result := Copy(pString, lIni, lFim - lIni);
end;
function mid(str:string; pos:integer):string;
begin
 result:=copy(str,pos, length(str)-pos+1);
end;
begin
  if System.Pos('<body', LowerCase(OrigHTML)) > 0 Then begin
    OrigHTML := Mid(OrigHTML, System.Pos('<body', LowerCase(OrigHTML)));
    OrigHTML := Mid(OrigHTML, System.Pos('>', OrigHTML) + 1);
    if System.Pos('</body>', LowerCase(OrigHTML)) > 0 Then
      OrigHTML := Copy(OrigHTML,1 , System.Pos('</body>', LowerCase(OrigHTML)) - 1);
  end;
  OrigHTML := StringReplace(OrigHTML, Chr(13), '', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, Chr(10), '', [rfReplaceAll]);
  while System.Pos('  ', OrigHTML) > 0 do
    OrigHTML := StringReplace(OrigHTML, '  ', ' ', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '<br>', #13#10, [rfReplaceAll, rfIgnoreCase]);
  OrigHTML := StringReplace(OrigHTML, '</div>', #13#10#13#10, [rfReplaceAll, rfIgnoreCase]);
  while System.Pos('<p', OrigHTML) > 0 do begin
    NoHTML   := MidStr(OrigHTML, '<p', '>', True);
    OrigHTML := StringReplace(OrigHTML, NoHTML, (#13#10#13#10), [rfReplaceAll, rfIgnoreCase]);
  end;
  while System.Pos('<', OrigHTML) > 0 do begin
    NoHTML   := MidStr(OrigHTML, '<', '>', True);
    OrigHTML := StringReplace(OrigHTML, NoHTML, '', [rfReplaceAll, rfIgnoreCase]);
  end;
  OrigHTML := StringReplace(OrigHTML, '&#36;',     '$', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '#37;',      '%', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&#187;',    '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&aacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&atilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ccedil;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&eacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ecirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&iacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&oacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ocirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&otilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Aacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Atilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ccedil;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Eacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ecirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Iacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Oacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ocirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Otilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&amp;',     '&', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&quot;',    '"', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&lt;',      '<', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&gt;',      '>', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&nbsp;',    ' ', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&copy;',    '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&reg;',     '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&raquo;',   '�', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&laquo;',   '�', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Uacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&uacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&uuml;',    '?', [rfReplaceAll]);
  result := OrigHTML;
end;

function TVectorDataItemBase.GetHintText: string;
var
  i,j: Integer;
begin
  Result := '';
  if (length(FName)>0) then begin
   if System.Pos('<',Fname)>0 then Result:=HTML2Txt(Fname)
                                 else Result:=Fname;
  end;
  if (length(FDesc)>0) then begin
   if length(Result)>0 then Result:=Result+#13#10;
   if System.Pos('<',Fdesc)>0 then Result:=Result+HTML2Txt(Fdesc)
                                  else Result:=Result+Fdesc;
  end;
  i:=1;
  j:=0;
  while (i<length(Result))and(i<>0) do begin
   inc(j);
   if (Result[i]=#13)or(Result[i]=#10) then j:=0;
   if (j>40)and(Result[i]=' ')and(length(Result)-i>5)then begin
     if i>500 then begin
       Insert('...',Result,i);
       Delete(Result,i+3,length(Result)-i+3);
       i:=0;
       continue;
     end;
     Delete(Result,i,1);
     Insert(#13#10,Result,i);
     j:=0;
    end;
   inc(i);
  end;
end;

function TVectorDataItemBase.GetInfoCaption: string;
begin
  Result := FName;
end;

function TVectorDataItemBase.GetInfoHTML: string;
begin
  Result := '';
  if Fdesc <> '' then begin
    Result:='<HTML><BODY>';
    Result:=Result+Fdesc;
    Result:=Result+'</BODY></HTML>';
  end;
end;

function TVectorDataItemBase.GetName: string;
begin
  Result := FName;
end;

end.
