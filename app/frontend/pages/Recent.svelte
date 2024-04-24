<script>
    export let likedFilms, reviewedFilms;
    import FilmGrid from "../components/filmGrid.svelte";
</script>

<h2 class="font-bold text-3xl text-teal-500 pt-5 pb-10">recently liked</h2>
<FilmGrid films={likedFilms} />

<h2 class="font-bold text-3xl text-teal-500 pt-5 pb-10">recently reviewed</h2>
<FilmGrid films={reviewedFilms} />
