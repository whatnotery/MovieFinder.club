<script>
    import ShowReview from "./showReview.svelte";
    export let reviews;
    export let userPage;
</script>

<div>
    {#if reviews}
        <div
            class="flex flex-row flex-wrap w-full items-start justify-center md:flex-row md:justify-start"
        >
            {#each reviews as review}
                <div class="w-[300px] px-4">
                    <ShowReview {review} {userPage} />
                </div>
            {/each}
        </div>
    {/if}
</div>
