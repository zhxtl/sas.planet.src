unit i_ILocalCoordConverterFactorySimpe;

interface

uses
  t_GeoTypes,
  i_ICoordConverter,
  i_ILocalCoordConverter;

type
  ILocalCoordConverterFactorySimpe = interface
    ['{102D5E00-4F2C-4425-9EB9-ED4DD77141FB}']
    function CreateConverter(
      AZoom: Byte;
      AGeoConverter: ICoordConverter;
      AMapScale: TDoublePoint;
      ALocalTopLeftAtMap: TDoublePoint
    ): ILocalCoordConverter;
  end;

implementation

end.
