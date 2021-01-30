module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  theme: {},
  variants: {
    extend: {
      opacity: ['disabled']
    }
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
