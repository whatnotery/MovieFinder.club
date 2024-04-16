<script>
    import FilmPosterAndTitle from "./filmPosterAndTitle.svelte";
    export let films;
</script>

<div>
    {#each films as film}
        <div>
            <FilmPosterAndTitle {film} />
        </div>
    {/each}
</div>
