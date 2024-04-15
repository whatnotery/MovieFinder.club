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
    <header class="flex">
        <div>
            <h1><a use:inertia href="/">📽️ MovieFinder.Club</a></h1>
        </div>
        <div class="flex">
            {#if user.id}
                <a use:inertia href="/discover/">Discover</a>
            {/if}
            <a use:inertia href="/films/recently_discovered"
                >Recently Discovered</a
            >
            {#if !user.id}
                <a use:inertia href="/sign_up">Sign Up</a>
            {/if}
            {#if user.id}
                <a use:inertia href="/users/{user.user_name}/">Profile</a>
                <button on:click={deleteSession}>Sign out</button>
            {:else}
                <SignIn />
            {/if}
        </div>
    </header>
    <section>
        <slot {user} />
    </section>
</main>

<style>
    main {
        font-family: "helvetica";
    }
    header {
        padding: 0px 1rem;
    }
    .flex {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        background-color: lightseagreen;
    }
    a {
        text-decoration: none;
        color: antiquewhite;
        padding: 0px 0.5rem;
    }
</style>
