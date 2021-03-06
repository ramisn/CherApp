module.exports = {
  env: {
    browser: true,
    es6: true,
  },
  extends: [
    'plugin:react/recommended',
    'airbnb',
  ],
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  plugins: [
    'react',
  ],
  rules: {
    "template-curly-spacing" : "off",
    indent : "off",
    "react/require-default-props": 0,
    "jsx-a11y/label-has-associated-control": "off"
  },
  settings: {
    'import/resolver': {
      node: {
        extensions: ['.js.jsx']
      }
    },
  },
  parser: "babel-eslint"
};
