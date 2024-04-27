<script>
    import FilmPosterAndTitle from "./filmPosterAndTitle.svelte";
    export let films;
    let currentPage = 1;
    const itemsPerPage = 14;
    const totalItems = films.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    function changePage(newPage) {
        currentPage = newPage;
    }

    $: paginatedFilms = films.slice(
        (currentPage - 1) * itemsPerPage,
        currentPage * itemsPerPage,
    );
</script>

{#if films && films.length > 0}
    <div class="flex flex-row flex-wrap w-full justify-center md:flex-row">
        {#if films.length > itemsPerPage}
            <div class="pb-4">
                <button
                    class="rounded-full w-10 text-orange-100 bg-teal-500 hover:text-orange-200"
                    on:click={() => changePage(currentPage - 1)}
                    disabled={currentPage === 1}
                    ><i class="fa-solid fa-chevron-left"></i></button
                >
                <span class="font-bold text-teal-500">
                    {currentPage} of {totalPages}</span
                >

                <button
                    class="rounded-full w-10 text-orange-100 bg-teal-500 hover:text-orange-200"
                    on:click={() => changePage(currentPage + 1)}
                    disabled={currentPage === totalPages}
                    ><i class="fa-solid fa-chevron-right"></i></button
                >
            </div>
        {/if}

        <div
            class="flex flex-row flex-wrap w-full items-center justify-start pb-6"
        >
            {#each paginatedFilms as film}
                <div class="w-[175px] px-4">
                    <FilmPosterAndTitle {film} />
                </div>
            {/each}
        </div>
    </div>
{:else}
    <p>No films to display.</p>
{/if}
