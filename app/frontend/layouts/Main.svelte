<script>
    import { inertia } from "@inertiajs/svelte";
</script>

<main>
    <header>
        <a use:inertia href="/">Home</a>

        <a use:inertia href="/users/sign_in">Sign In</a>
    </header>
    <section>
        <slot />
    </section>
</main>
