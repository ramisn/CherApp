const DEFAULT_ESTATE = 'California';
const DEFAULT_CITY_NAME = 'Santa Monica';
const DEFAULT_VENDOR = 'claw';
const AVAILABLE_VENDORS = ['claw', 'crmls', 'beaor'];

function sanitizedPropertyAddress(property) {
  const address = `${property.address.full}, ${property.address.city}`;
  return address.replace(/ave[, ]/i, 'Avenue,')
                .replace(/blv/i, 'Boulevard')
                .replace(/boulevardd/i, 'Boulevard')
                .replace(/dr,/i, 'Drive,')
                .replace(/pl,/i, 'Place,')
                .replace(/st,/i, 'Street,');
}

function numToCurrency(price) {
  return price.toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
}

function randomizeProperties(properties, number) {
  return properties.sort(() => Math.random() - Math.random()).slice(0, number);
}

export {
          numToCurrency,
          sanitizedPropertyAddress,
          randomizeProperties,
          DEFAULT_CITY_NAME,
          DEFAULT_VENDOR,
          AVAILABLE_VENDORS,
          DEFAULT_ESTATE,
        };
