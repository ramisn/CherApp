export const POLYGON_DEFAULT_OPTIONS = {
  strokeColor: '#1600FF',
  strokeOpacity: 0.8,
  strokeWeight: 2,
  fillColor: '#1600FF',
  fillOpacity: 0.35,
  draggable: true,
  geodesic: true,
  editable: true,
};

export const getCoordinatesFromPath = (path) => ({ lat: path.lat(), lng: path.lng() });

const PARSERS = {
  circle: (shape) => {
    const numPts = 100;
    const path = [];
    for (let i = 0; i < numPts; i += 1) {
      const position = (i * 360) / numPts;
      const offset = google.maps.geometry.spherical.computeOffset(shape.getCenter(),
                                                                  shape.getRadius(), position);
      path.push({ lat: offset.lat(), lng: offset.lng() });
    }

    return {
      coordinates: path,
      radius: shape.getRadius(),
      center: [getCoordinatesFromPath(shape.getCenter())],
    };
  },

  polygon: (shape) => {
    const coordinates = [];

    shape.getPath().forEach((path) => coordinates.push(getCoordinatesFromPath(path)));

    return { coordinates };
  },

  rectangle: (shape) => {
    const bounds = shape.getBounds();
    const NE = bounds.getNorthEast();
    const SW = bounds.getSouthWest();
    const NW = new google.maps.LatLng(NE.lat(), SW.lng());
    const SE = new google.maps.LatLng(SW.lat(), NE.lng());

    return {
      coordinates: [
        { lat: NE.lat(), lng: NE.lng() },
        { lat: SW.lat(), lng: SW.lng() },
        { lat: NW.lat(), lng: NW.lng() },
        { lat: SE.lat(), lng: SE.lng() },
      ],
    };
  },
};

export const getShapeProperties = (shapeType, shape) => PARSERS[shapeType](shape);

export const getPointString = (shapeProperties) => {
  const points = shapeProperties.coordinates.map((p) => `${p.lat},${p.lng}`);

  return JSON.stringify(points);
};

export const capitalizeFirstLetter = ([first, ...rest], locale = navigator.language) => (
  first.toLocaleUpperCase(locale) + rest.join('')
);
