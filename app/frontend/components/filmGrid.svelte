<script>
    import FilmPosterAndTitle from "./filmPosterAndTitle.svelte";
    export let films;
</script>

<div id="wrap">
    {#each films as film}
        <div id="fpt">
            <FilmPosterAndTitle {film} />
        </div>
    {/each}
</div>

<style>
    #wrap {
        display: flex;
        flex-direction: row;
        width: 95%;
        flex-wrap: wrap;
        margin: auto;
    }
    #fpt {
        width: 15rem;
    }
</style>
