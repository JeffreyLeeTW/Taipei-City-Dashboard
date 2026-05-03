import ntpcLogo from "./logo-icon-ntpc.svg";
import tpeLogo from "./logo-icon-tpe.svg";

const chatbotLogos = [ntpcLogo, tpeLogo];
const selectedChatbotLogo =
	chatbotLogos[Math.floor(Math.random() * chatbotLogos.length)];

export default selectedChatbotLogo;
