<script>
    export let pageTitle, filmsArray;
    import FilmGrid from "../components/filmGrid.svelte";
</script>

<h2 class="text-3xl text-teal-500 pt-5 pb-10">{pageTitle}</h2>
<FilmGrid films={filmsArray} />
