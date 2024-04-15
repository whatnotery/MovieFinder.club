<script>
    import { inertia } from "@inertiajs/svelte";
    import SignIn from "../components/SignIn.svelte";
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

<main>
    <header class="flex">
        <div>
            <h1><a use:inertia href="/">📽️ MovieFinder.Club</a></h1>
        </div>
    </header>
    <section>
        <h2></h2>
        <slot />
    </section>
</main>

<style>
    section {
        font-family: "Montserrat", sans-serif;
        min-height: 95vh;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
    }
    header {
        padding: 0px 1rem;
        background-color: lightseagreen;
    }
    .flex {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }
    a {
        text-decoration: none;
        color: antiquewhite;
        font-family: "helvetica";
        padding: 0px 0.5rem;
    }
</style>
