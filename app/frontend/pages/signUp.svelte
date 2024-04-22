<script>
    import axios from "axios";
    let formData = {
        user: {
            email: null,
            user_name: null,
            first_name: null,
            last_name: null,
            letterboxd: null,
            instagram: null,
            bio: null,
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

<form on:submit|preventDefault={submit} class="flex flex-col items-center">
    <h3 class="text-4xl text-teal-500">Sign Up</h3>
    <div class="py-2 my-4">
        <div class="py-2">
            <label for="email" hidden>Email</label>
            <input
                class="rounded-full border-teal-500"
                name="email"
                type="text"
                placeholder="Email"
                autocomplete="email"
                bind:value={formData.user.email}
            />

            <label for="user_name" hidden>User Name</label>
            <input
                class="rounded-full border-teal-500"
                name="user_name"
                type="text"
                placeholder="User Name"
                bind:value={formData.user.user_name}
            />
        </div>
        <div class="py-2">
            <label for="first_name" hidden>First Name</label>
            <input
                class="rounded-full border-teal-500"
                name="first_name"
                type="text"
                placeholder="First Name"
                bind:value={formData.user.first_name}
            />

            <label for="last_name" hidden>Last Name</label>
            <input
                class="rounded-full border-teal-500"
                name="last_name"
                type="text"
                placeholder="Last Name"
                bind:value={formData.user.last_name}
            />
        </div>
        <div class="py-2">
            <label for="letterboxd" hidden>letterboxd</label>
            <input
                class="rounded-full border-teal-500"
                name="letterboxd"
                type="text"
                placeholder="letterboxd username"
                bind:value={formData.user.letterboxd}
            />

            <label for="instagram" hidden>instagram</label>
            <input
                class="rounded-full border-teal-500"
                name="instagram"
                type="text"
                placeholder="instagram username"
                bind:value={formData.user.instagram}
            />
        </div>
        <div class="py-2">
            <label for="bio" hidden>bio</label>
            <textarea
                class="w-full rounded-full border-teal-500"
                name="bio"
                type="bio"
                placeholder="bio"
                bind:value={formData.user.bio}
            />
        </div>
        <div class="py-2">
            <label for="password" hidden>Password</label>
            <input
                class="rounded-full border-teal-500"
                name="password"
                type="password"
                placeholder="Password"
                autocomplete="current-password"
                bind:value={formData.user.password}
            />
            <label for="password_confirmation" hidden
                >Password Confirmation</label
            >
            <input
                class="rounded-full border-teal-500"
                name="password_confirmation"
                type="password"
                placeholder="Password Confirmation"
                bind:value={formData.user.password_confirmation}
            />
        </div>
    </div>
    <button
        class="rounded-full w-32 text-orange-100 bg-teal-500 py-2 hover:text-orange-200"
        type="submit">Submit</button
    >
</form>
