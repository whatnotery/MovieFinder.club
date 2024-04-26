<script>
    import axios from "axios";
    import { currentUser } from "../lib/auth";
    export let review;
    export let userPage;

    let userPromise = currentUser();
</script>

<div class="py-5">
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
