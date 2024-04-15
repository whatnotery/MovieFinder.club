<script>
    import axios from "axios";
    let formData = {
        user: {
            email: null,
            user_name: null,
            first_name: null,
            last_name: null,
            password: null,
            password_confirmation: null,
        },
    };

    async function submit() {
        try {
            const response = await axios.post("/users", formData);
            window.location.href = "/sign_in";
        } catch (error) {
            console.error("Error submitting form:", error);
        }
    }
</script>

<form on:submit|preventDefault={submit}>
    <label for="email" hidden>Email</label>
    <input
        name="email"
        type="text"
        placeholder="Email"
        autocomplete="email"
        bind:value={formData.user.email}
    />

    <label for="user_name" hidden>User Name</label>
    <input
        name="user_name"
        type="text"
        placeholder="User Name"
        bind:value={formData.user.user_name}
    />

    <label for="first_name" hidden>First Name</label>
    <input
        name="first_name"
        type="text"
        placeholder="First Name"
        bind:value={formData.user.first_name}
    />

    <label for="last_name" hidden>Last Name</label>
    <input
        name="last_name"
        type="text"
        placeholder="Last Name"
        bind:value={formData.user.last_name}
    />
    <label for="password" hidden>Password</label>
    <input
        name="password"
        type="password"
        placeholder="Password"
        autocomplete="current-password"
        bind:value={formData.user.password}
    />
    <label for="password_confirmation" hidden>Password Confirmation</label>
    <input
        name="password_confirmation"
        type="password"
        placeholder="Password Confirmation"
        bind:value={formData.user.password_confirmation}
    />
    <button type="submit">Submit</button>
</form>
