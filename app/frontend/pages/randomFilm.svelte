<script>
    import { onMount } from "svelte";
    import { createEventDispatcher } from "svelte";
    import Layout from "../layouts/Main.svelte";

    const dispatch = createEventDispatcher();

    let currentFilmData = {
        title: "",
        poster: "",
        plot: "",
        imdb_id: "",
        id: "",
        youtube_link: "",
        streaming_providers: [],
        rental_providers: [],
    };

    onMount(() => {
        fetchRandomFilm();
    });

    async function fetchRandomFilm() {
        const response = await fetch("/films/random", {
            method: "GET",
            headers: {
                "X-Requested-With": "XMLHttpRequest",
            },
        });
        const data = await response.json();
        currentFilmData = {
            title: `${data.title} (${data.year})`,
            poster: `https://image.tmdb.org/t/p/w300/${data.poster}`,
            plot: data.plot,
            imdb_id: data.imdb_id,
            id: data.id,
            youtube_link: data.youtube_link,
            streaming_providers: data.streaming_providers || [],
            rental_providers: data.rental_providers || [],
        };
    }

    function handleNewFilmClick() {
        fetchRandomFilm();
    }
</script>

<div id="filmContainer">
    <section>
        {#if currentFilmData.poster}
            <img
                src={currentFilmData.poster}
                alt={`Movie poster for ${currentFilmData.title}`}
            />
        {/if}
    </section>
    <section id="filmtext">
        <a
            href={`https://www.google.com/search?q=${currentFilmData.title.split(" ").join("+")}+film&tbm=vid`}
            target="_blank"
            rel="noopener noreferrer"
        >
            <h2>{currentFilmData.title}</h2>
        </a>
        <a
            href={`https://www.imdb.com/title/${currentFilmData.imdb_id}`}
            target="_blank"
            rel="noopener noreferrer">IMDB</a
        >
        |
        <a
            href={`https://www.themoviedb.org/movie/${currentFilmData.id}`}
            target="_blank"
            rel="noopener noreferrer">The Movie DB</a
        >
        |
        <a
            href={currentFilmData.youtube_link}
            target="_blank"
            rel="noopener noreferrer">Youtube Trailer</a
        >
        <p>{currentFilmData.plot}</p>
        <b>Streaming Providers:</b>
        <p>
            {currentFilmData.streaming_providers.length > 0
                ? currentFilmData.streaming_providers.join(", ")
                : "None"}
        </p>
        <b>Rental Providers:</b>
        <p>
            {currentFilmData.rental_providers.length > 0
                ? currentFilmData.rental_providers.join(", ")
                : "None"}
        </p>

        <button on:click={handleNewFilmClick}>New Film</button>
    </section>
</div>
