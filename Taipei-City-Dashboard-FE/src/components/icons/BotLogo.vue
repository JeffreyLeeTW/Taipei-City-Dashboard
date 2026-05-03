<script setup>
import selectedChatbotLogo from "./chatbotLogo";
</script>

<template>
  <span
    class="bot-logo"
    role="img"
    aria-label="Bot Logo"
  >
    <img
      class="bot-logo__image"
      :src="selectedChatbotLogo"
      alt=""
    >
  </span>
</template>

<style scoped lang="scss">
.bot-logo {
  position: relative;
  display: inline-block;
  width: 39px;
  height: 39px;
  overflow: hidden;
  border-radius: 50%;
  vertical-align: middle;
}

.bot-logo__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
}
</style>
