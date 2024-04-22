<script>
    import axios from "axios";
    import { currentUser } from "../lib/auth";
    export let review;
    export let userPage;

    async function getFilm() {
        const response = await axios.get(`/api/films/${review.mdb_id}`);
        return response.data;
    }
    let filmPromise = getFilm();
    let userPromise = currentUser();
</script>

<div class="py-5">
    {#if userPage === "true"}
        {#await filmPromise}
            <p>...waiting</p>
        {:then film}
            <h4 class="text-lg">
                <a
                    use:inertia
                    class="font-bold text-xl text-teal-500 hover:text-teal-600"
                    href="/films/{review.mdb_id}">Review for {film.title}</a
                >
            </h4>
        {:catch error}
            <p style="color: red">{error.message}</p>
        {/await}
    {/if}
    <br />
    <div class="flex flex-row items-start justify-between">
        {#if userPage === "false"}
            {#await userPromise}
                <p>...waiting</p>
            {:then user}
                <div>
                    <h4 class="font-bold text-lg text-teal-500">
                        {review.title}
                    </h4>
                    by
                    <a
                        use:inertia
                        class="text-teal-500 hover:text-teal-600"
                        href="/users/{user.user_name}">{user.user_name}</a
                    >
                </div>
            {:catch error}
                <p style="color: red">{error.message}</p>
            {/await}
        {:else}
            <h4 class="font-bold text-lg text-teal-500">
                {review.title}
            </h4>
        {/if}
        <div>
            {#each { length: review.rating } as i}
                <i class="text-teal-500 fa-solid fa-star"></i>
            {/each}
        </div>
    </div>
    <br />
    {review.body}
</div>
