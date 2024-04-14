import { createInertiaApp } from '@inertiajs/svelte'
import main from '../layouts/Main.svelte'
import home from '../pages/Home.svelte'

createInertiaApp({
  resolve: name => {
    const pages = import.meta.glob('../pages/**/*.svelte', { eager: true })
    let page = pages[`../${name}.svelte`]
    return {
      default: page.default,
      layout: main
    }
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})