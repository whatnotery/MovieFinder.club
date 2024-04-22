<script>
    import { inertia } from "@inertiajs/svelte";
</script>

<main class="w-screen">
    <header
        class="flex flex-wrap justify-center items-center text-orange-100 bg-teal-500 md:flex-row"
    >
        <h1 class="text-4xl text-nowrap py-3">
            <a use:inertia href="/">📽️ MovieFinder.Club</a>
        </h1>
    </header>
    <section>
        <div
            class="flex flex-col justify-center placeholder:text-teal-400 align-center text-center pt-9"
        >
            <slot />
        </div>
    </section>
</main>
