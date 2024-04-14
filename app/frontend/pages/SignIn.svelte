<script>
    import Layout from "../layouts/Main.svelte";
    import { useForm } from "@inertiajs/svelte";
    import { csrfToken } from "../lib/auth.js";
    let form = useForm({
        user: {
            email: null,
            password: null,
        },
    });

    function submit() {
        $form.post("/users/sign_in");
    }
</script>

<form on:submit|preventDefault={submit}>
    <input type="text" bind:value={$form.email} />
    {#if $form.errors.email}
        <div class="form-error">{$form.errors.email}</div>
    {/if}
    <input type="password" bind:value={$form.password} />
    {#if $form.errors.password}
        <div class="form-error">{$form.errors.password}</div>
    {/if}
    <button type="submit" disabled={$form.processing}>Submit</button>
</form>
