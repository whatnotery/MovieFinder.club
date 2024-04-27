<script>
    import { inertia } from "@inertiajs/svelte";
    import axios from "axios";

    export let review;
    export let userPage;

    // Fetch user data based on user_id from the review
    async function getUser(user_id) {
        const response = await axios.get(`/api/users/${user_id}`);
        console.log(response);
        return response.data;
    }
</script>

<div class="py-5">
    <div class="flex flex-row items-start justify-between">
        {#await getUser(review.user_id)}
            <p>...waiting</p>
        {:then user}
            {#if user && !userPage}
                <div>
                    <h4 class="font-bold text-lg text-teal-500">
                        {review.title}
                    </h4>
                    by
                    <a
                        use:inertia
                        class="text-teal-500 hover:text-teal-600"
                        href={`/users/${user.user_name}`}>{user.user_name}</a
                    >
                </div>
            {:else}
                <h4 class="font-bold text-lg text-teal-500">
                    {review.title}
                </h4>
            {/if}
        {:catch error}
            <p style="color: red">{error.message}</p>
        {/await}

        <div class="text-nowrap">
            {#each Array(review.rating).fill() as _, i}
                <i class="text-teal-500 fa-solid fa-star"></i>
            {/each}
        </div>
    </div>
    <br />
    {review.body}
</div>
