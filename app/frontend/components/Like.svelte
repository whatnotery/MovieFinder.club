<script>
    import axios from "axios";
    export let filmId;

    export async function likeFilm() {
        axios.post(`/films/${filmId}/like`);
        window.location.href = `/films/${filmId}`;
    }
</script>

<button on:click={likeFilm}>Like Film</button>
