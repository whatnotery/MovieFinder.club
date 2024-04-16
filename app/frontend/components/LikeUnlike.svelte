<script>
    import axios from "axios";
    export let filmId;
    export let liked;

    async function likeFilm() {
        axios.post(`/films/${filmId}/like`);
        window.location.href = `/films/${filmId}`;
    }

    async function unlikeFilm() {
        axios.post(`/films/${filmId}/unlike`);
        window.location.href = `/films/${filmId}`;
    }
</script>

{#if liked}
    <button on:click={unlikeFilm}>Unlike Film</button>
{:else}
    <button on:click={likeFilm}>Like Film</button>
{/if}
