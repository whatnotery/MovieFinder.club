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
    <header class="flex flex-wrap justify-center text-orange-100 bg-teal-500">
        <div>
            <h1 class="text-8xl py-3">
                <a use:inertia href="/">📽️ MovieFinder.Club</a>
            </h1>
        </div>
    </header>
    <section>
        <h2>Sign In</h2>
        <slot />
    </section>
</main>
