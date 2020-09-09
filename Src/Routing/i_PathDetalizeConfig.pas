{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2020, SAS.Planet development team.                      *}
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

unit i_PathDetalizeConfig;

interface

uses
  i_ConfigDataElement;

type
  IPathDetalizeConfig = interface(IConfigDataElement)
    ['{BD3A7204-23C6-4DA5-AB16-35996256F5D6}']

    function GetEnableAutomaticRouting: Boolean;
    procedure SetEnableAutomaticRouting(const AValue: Boolean);
    property EnableAutomaticRouting: Boolean read GetEnableAutomaticRouting write SetEnableAutomaticRouting;

    function GetDefaultProvider: TGUID;
    procedure SetDefaultProvider(const AValue: TGUID);
    property DefaultProvider: TGUID read GetDefaultProvider write SetDefaultProvider;
  end;

implementation

end.
