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
    <button
        class="rounded-full w-20 h-10 text-orange-100 bg-teal-500 m-2 py-2 hover:text-orange-200"
        on:click={unlikeFilm}
        >liked <i class="fa-solid fa-thumbs-up"></i></button
    >
{:else}
    <button
        class="rounded-full w-20 h-10 text-orange-100 bg-teal-500 m-2 py-2 hover:text-orange-200"
        on:click={likeFilm}
        >like <i class="fa-regular fa-thumbs-up"></i>
    </button>
{/if}
