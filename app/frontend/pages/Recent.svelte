<script>
    export let pageTitle, filmsArray;
    import FilmGrid from "../components/filmGrid.svelte";
</script>

<h2>{pageTitle}</h2>
<FilmGrid films={filmsArray} />
