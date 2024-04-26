<script>
    import axios from "axios";
    import FilmGrid from "../components/filmGrid.svelte";

    let searchQuery = ""; // Initialize searchQuery to avoid undefined errors
    let results = []; // Store search results
    let error = null; // Track any errors that occur
    let searching = false; // Track if a search is in progress

    async function search() {
        error = null; // Reset error on new search
        searching = true; // Indicate search has started
        try {
            const response = await axios.get(
                `/api/films/search?query=${encodeURIComponent(searchQuery)}`,
            );
            results = response.data; // Assuming the server returns an array of films
        } catch (err) {
            error = "Error submitting form: " + err.message; // Capture and display errors
            results = []; // Reset results on error
        } finally {
            searching = false; // Search has completed
        }
    }
</script>

<form
    on:submit|preventDefault={search}
    class="flex flex-col justify-center items-center pb-10"
>
    <h3 class=" font-bold pt-6 text-4xl text-teal-500">Search</h3>
    <div class="py-2 my-4">
        <input
            class="rounded-full border-teal-500"
            type="text"
            placeholder="Search"
            autocomplete="search"
            bind:value={searchQuery}
        />
    </div>
    <button
        class="rounded-full w-32 text-orange-100 bg-teal-500 py-2 hover:text-orange-200"
        type="submit"
        disabled={searchQuery.trim() === "" || searching}>Search</button
    >
</form>

<!-- Handle different states of the search -->
{#if searching}
    <p>Loading...</p>
{:else if results.length > 0}
    <FilmGrid films={results} />
{:else if error}
    <p class="error">{error}</p>
{/if}
