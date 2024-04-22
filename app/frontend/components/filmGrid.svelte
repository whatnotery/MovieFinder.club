<script>
    import FilmPosterAndTitle from "./filmPosterAndTitle.svelte";
    export let films;
</script>

<div>
    {#if films}
        <div
            class="flex flex-row flex-wrap w-full items-end justify-center md:flex-row md:justify-start"
        >
            {#each films as film}
                <div class="w-[175px] px-4">
                    <FilmPosterAndTitle {film} />
                </div>
            {/each}
        </div>
    {/if}
</div>
