import { createInertiaApp } from '@inertiajs/svelte'
import main from '../layouts/Main.svelte'
import signIn from '../layouts/SignIn.svelte'
import home from '../pages/Home.svelte'

createInertiaApp({
  resolve: name => {
    const pages = import.meta.glob('../pages/**/*.svelte', { eager: true })
    let page = pages[`../${name}.svelte`]

    let layout = main

    if (name == "pages/signIn" || name == "pages/signUp") {
      layout = signIn
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