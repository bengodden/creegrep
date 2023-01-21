<script setup>
import { RouterLink, RouterView } from "vue-router";
</script>

<template>
  <div id="main">
    <!-- <nav>
      <RouterLink to="/">Home</RouterLink>
      <RouterLink to="/about">About</RouterLink>
    </nav> -->

    <RouterView />
  </div>
</template>

<style scoped>
#main {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  width: 100%;

  border-radius: 0.5em;
}

header {
  line-height: 1.5;
  max-height: 100vh;
}

nav {
  font-size: 2em;
  text-align: right;
  margin-top: 3rem;
  background: #6699ff;
  border-radius: 1em;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  text-align: right;
  border-left: 1px solid var(--color-border);
}

/* @media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  nav {
    text-align: right;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
} */
</style>
