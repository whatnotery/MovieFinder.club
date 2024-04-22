<script>
    import axios from "axios";
    export let filmId;
    export let favorite;

    async function favoriteFilm() {
        axios.post(`/films/${filmId}/favorite`);
        window.location.href = `/films/${filmId}`;
    }

    async function unfavoriteFilm() {
        axios.post(`/films/${filmId}/unfavorite`);
        window.location.href = `/films/${filmId}`;
    }
</script>

{#if favorite}
    <button
        class="rounded-full w-32 text-orange-100 bg-teal-500 m-2 py-2 hover:text-orange-200"
        on:click={unfavoriteFilm}
        >unfavorite <i class="fa-solid fa-star"></i></button
    >
{:else}
    <button
        class="rounded-full w-32 text-orange-100 bg-teal-500 m-2 py-2 hover:text-orange-200"
        on:click={favoriteFilm}
        >favorite <i class="fa-regular fa-star"></i>
    </button>
{/if}
