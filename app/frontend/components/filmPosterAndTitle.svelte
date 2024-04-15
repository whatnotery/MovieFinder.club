<script>
    export let film;
</script>

<div id="posterTitle">
    <h4><a href="/films/{film.mdb_id}">{film.title} ({film.year})</a></h4>

    <img
        src="https://image.tmdb.org/t/p/w300/{film.poster}"
        alt={`Movie poster for ${film.title}`}
        width="200px"
    />
</div>

<style>
    h4 {
        font-family: "helvetica";
    }
    #posterTitle {
        display: flex;
        justify-content: center;
        flex-direction: column;
        align-items: center;
    }
</style>
