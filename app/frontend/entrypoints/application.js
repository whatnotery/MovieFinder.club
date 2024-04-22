import { createInertiaApp } from '@inertiajs/svelte'
import main from '../layouts/Main.svelte'
import SignInSignUp from '../layouts/SignInSignUp.svelte'
import '../stylesheets/main.css'

createInertiaApp({
  resolve: name => {
    const pages = import.meta.glob('../pages/**/*.svelte', { eager: true })
    let page = pages[`../${name}.svelte`]

    let layout = main

    if (name == "pages/signIn" || name == "pages/signUp") {
      layout = SignInSignUp
    }

    return {
      default: page.default,
      layout: layout
    }
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})