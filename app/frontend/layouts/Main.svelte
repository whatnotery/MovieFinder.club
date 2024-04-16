<script>
    import { inertia } from "@inertiajs/svelte";
    import SignIn from "../components/SignIn.svelte";
    import { deleteSession, currentUser } from "../lib/auth";
    let userPromise = currentUser();
    let user = {};
    userPromise
        .then((result) => {
            user = result;
            setContext("user", user);
        })
        .catch((error) => {
            // Handle errors
        });
</script>

<main>
    <header class="flex flex-wrap justify-center text-orange-100 bg-teal-500">
        <div>
            <h1 class="text-8xl py-3">
                <a use:inertia href="/">📽️ MovieFinder.Club</a>
            </h1>
        </div>
        <div class="flex justify-around pt-2 pb-3 w-screen text-5xl">
            {#if user.id}
                <a use:inertia href="/discover/">Discover</a>
                <a use:inertia href="/films/recently_discovered">Recent</a>
                <a use:inertia href="/users/{user.user_name}">Profile</a>
                <button on:click={deleteSession}>Sign out</button>
            {:else}
                <a use:inertia href="/sign_in">Sign In</a>

                <a use:inertia href="/sign_up">Sign up</a>
            {/if}
        </div>
    </header>
    <section>
        <slot {user} />
    </section>
</main>
