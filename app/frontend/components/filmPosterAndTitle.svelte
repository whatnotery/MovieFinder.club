<script>
    export let film;
</script>

<div>
    <h4><a href="/films/{film.mdb_id}">{film.title} ({film.year})</a></h4>

    <img
        src="https://image.tmdb.org/t/p/w300/{film.poster}"
        alt={`Movie poster for ${film.title}`}
        width="200px"
    />
</div>
