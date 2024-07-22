const js = require("@eslint/js");
const globals = require("globals");

const googleStyleRules = require("eslint-config-google");

// Remove the 'valid-jsdoc' rule from googleStyleRules
delete googleStyleRules.rules["valid-jsdoc"];

module.exports = [
  js.configs.recommended,
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2018,
      sourceType: "module",
      globals: {
        ...globals.es6,
        ...globals.node,
      },
    },
    rules: {
      ...googleStyleRules.rules,
      "no-restricted-globals": ["error", "name", "length"],
      "prefer-arrow-callback": "error",
      "quotes": ["error", "double", {"allowTemplateLiterals": true}],
    },
  },
  {
    files: ["**/*.spec.*"],
    languageOptions: {
      globals: {
        ...globals.mocha,
      },
    },
    rules: {},
  },
];
