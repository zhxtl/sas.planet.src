{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit i_AntiBan;

interface

uses
  
  i_DownloadRequest,
  i_DownloadResult,
  i_DownloadResultFactory;

type
  IAntiBan = interface
    ['{19B5BF44-50AA-43C9-BC2C-94A92A85A209}']
    procedure PreDownload(
      ARequest: IDownloadRequest
    );
    function PostCheckDownload(
      AResultFactory: IDownloadResultFactory;
      ARequest: IDownloadRequest;
      const ARecivedSize: Integer;
      const ARecivedBuffer: Pointer;
      var AStatusCode: Cardinal;
      var AResponseHead: string
    ): IDownloadResult;
  end;

implementation

end.
