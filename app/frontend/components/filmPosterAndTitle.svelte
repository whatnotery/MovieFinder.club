<script>
    import { inertia } from "@inertiajs/svelte";
    export let film;
</script>

<h4 class="font-bold text-xl text-teal-500 hover:text-teal-600">
    <a use:inertia class="text-wrap" href="/films/{film.mdb_id}"
        >{film.title} ({film.year})
        <img
            src="https://image.tmdb.org/t/p/w300/{film.poster}"
            alt={`Movie poster for ${film.title}`}
            width="200px"
        />
    </a>
</h4>
