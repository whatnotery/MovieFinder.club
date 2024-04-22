<script>
    import axios from "axios";
    import FilmPosterAndTitle from "../components/filmPosterAndTitle.svelte";

    export let film;

    let formData = {
        review: {
            title: null,
            rating: null,
            body: null,
            mdb_id: `${film.mdb_id}`,
        },
    };

    async function submit() {
        try {
            const response = await axios.post(
                `/films/${film.mdb_id}/review`,
                formData,
            );

            window.location.href = `/films/${film.mdb_id}`;
        } catch (error) {
            console.error("Error submitting form:", error);
        }
    }
</script>

<div class="w-full flex flex-col items-center pt-6">
    <FilmPosterAndTitle {film} />

    <form on:submit|preventDefault={submit} class="flex flex-col items-center">
        <label for="title" hidden>title</label>
        <input
            class="mt-5 rounded-full border-teal-500"
            name="title"
            type="text"
            placeholder="review title"
            autocomplete="title"
            bind:value={formData.review.title}
        />
        <label class="mt-3 text-teal-500" for="rating">rating</label>

        <input
            class="rounded-full border-teal-500"
            type="number"
            name="rating"
            min="0"
            max="5"
            step="1"
        />
        <label for="review" hidden>review</label>

        <textarea
            class="mt-3 rounded-full border-teal-500"
            name="review"
            type="review"
            placeholder="review"
            autocomplete="review"
            bind:value={formData.review.body}
        />

        <button
            class="mt-3 rounded-full w-32 text-orange-100 bg-teal-500 py-2 hover:text-orange-200"
            type="submit">submit review</button
        >
    </form>
</div>
