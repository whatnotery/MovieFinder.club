<script>
    import { inertia } from "@inertiajs/svelte";
    import { deleteSession, currentUser } from "../lib/auth";
    let userPromise = currentUser();
    let user = {};
    userPromise
        .then((result) => {
            user = result;
        })
        .catch((error) => {
            // Handle errors
        });
</script>

<main class="w-screen">
    <header
        class="flex flex-wrap md:flex-nowrap justify-center items-center text-orange-100 bg-teal-500 md:flex-row"
    >
        <h1 class="text-3xl text-nowrap py-3 md:pl-2">
            <a use:inertia href="/"><span>📽️ MovieFinder.Club</span></a>
        </h1>
        <div
            class="text-xs flex flex-row w-full justify-around pt-2 pb-3 text-2xl md:text-xl md:justify-end"
        >
            {#if user.id}
                <a
                    use:inertia
                    class="px-5 hover:text-orange-200"
                    href="/discover/">Discover</a
                >
                <a use:inertia class="px-5 hover:text-orange-200" href="/search"
                    >Search</a
                >
                <a
                    use:inertia
                    class="px-5 hover:text-orange-200"
                    href="/films/recent">Recent</a
                >
                <a
                    use:inertia
                    class="px-5 hover:text-orange-200"
                    href="/users/{user.user_name}">Profile</a
                >
                <button
                    class="px-5 hover:text-orange-200"
                    on:click={deleteSession}>Sign out</button
                >
            {:else}
                <a
                    use:inertia
                    class="px-5 hover:text-orange-200"
                    href="/sign_in">Sign In</a
                >

                <a
                    use:inertia
                    class=" px-5 hover:text-orange-200"
                    href="/sign_up">Sign up</a
                >
            {/if}
        </div>
    </header>
    <section class="mx-8">
        <slot />
    </section>
</main>
