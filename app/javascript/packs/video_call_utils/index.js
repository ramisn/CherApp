export const toCamel = (str) => {
  if (!str) return '';

  const s = str.replace(/([-_][a-z])/ig, (part) => part.toUpperCase().replace('_', ''));
  return s.charAt(0).toUpperCase() + s.slice(1);
};

const isArray = (a) => Array.isArray(a);

const isObject = (o) => o === Object(o) && !isArray(o) && typeof o !== 'function';

export const parseMeetingParams = (params) => {
  if (isObject(params)) {
    const n = {};

    Object.keys(params)
      .forEach((k) => {
        n[toCamel(k)] = parseMeetingParams(params[k]);
      });

    return n;
  }

  if (isArray(params)) {
    return params.map((i) => parseMeetingParams(i));
  }

  return params;
};

export const userNameFromExternalUserId = (externalUserID) => (
  externalUserID?.includes('@') ? externalUserID : toCamel(externalUserID)
);

