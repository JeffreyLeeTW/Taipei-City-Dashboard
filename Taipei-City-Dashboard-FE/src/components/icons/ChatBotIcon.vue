<script setup>
import selectedChatbotLogo from "./chatbotLogo";
</script>

<template>
  <span
    class="chatbot-icon"
    role="img"
    aria-label="Chatbot Icon"
  >
    <img
      class="chatbot-icon__image"
      :src="selectedChatbotLogo"
      alt=""
    >
  </span>
</template>

<style scoped lang="scss">
.chatbot-icon {
  display: inline-flex;
  width: 100%;
  height: 100%;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 50%;
}

.chatbot-icon__image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}
</style>
