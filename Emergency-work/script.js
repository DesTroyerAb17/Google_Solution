const emergencies = [
    {
        title: "CPR",
        cardImage: "https://www.sja.org.uk/globalassets/first-aid-steps-illustrations/cpr-step-3.png",
        steps: [
            { text: "Check if the person is unresponsive and call emergency services.", image: "https://via.placeholder.com/300x200?text=CPR+Step+1" },
            { text: "Place them on a firm surface and kneel beside them.", image: "https://via.placeholder.com/300x200?text=CPR+Step+2" },
            { text: "Start chest compressions (30 compressions at 100-120 per minute).", image: "https://via.placeholder.com/300x200?text=CPR+Step+3" },
            { text: "Give 2 rescue breaths and repeat cycles until help arrives.", image: "https://via.placeholder.com/300x200?text=CPR+Step+4" }
        ]
    },
    {
        title: "Choking",
        cardImage:"https://www.spectrumhealthlakeland.org/health-wellness/health-library/GetImage/532447",
        steps: [
            { text: "Ask if they can breathe. If not, call emergency services.", image: "https://via.placeholder.com/300x200?text=Choking+Step+1" },
            { text: "Perform 5 strong back blows between the shoulder blades.", image: "https://via.placeholder.com/300x200?text=Choking+Step+2" },
            { text: "If still choking, perform 5 abdominal thrusts (Heimlich maneuver).", image: "https://via.placeholder.com/300x200?text=Choking+Step+3" },
            { text: "Continue until the object is expelled or help arrives.", image: "https://via.placeholder.com/300x200?text=Choking+Step+4" }
        ]
    },
    {
        title: "Burns",
        cardImage: "https://png.pngtree.com/png-clipart/20230323/original/pngtree-hand-with-burn-beware-fired-wound-caution-attention-risk-png-image_8999951.png",
        steps: [
            { text: "Remove the person from the heat source.", image: "https://via.placeholder.com/300x200?text=Burns+Step+1" },
            { text: "Cool the burn with running water for at least 10 minutes.", image: "https://via.placeholder.com/300x200?text=Burns+Step+2" },
            { text: "Cover the burn with a clean cloth, do not pop blisters.", image: "https://via.placeholder.com/300x200?text=Burns+Step+3" },
            { text: "Seek medical help if the burn is severe.", image: "https://via.placeholder.com/300x200?text=Burns+Step+4" }
        ]
    },
    {
        title: "Heart Attack",
        cardImage:"https://static.vecteezy.com/system/resources/previews/027/140/250/non_2x/hand-drawn-cartoon-illustration-of-a-man-touching-a-heart-fights-chest-pain-and-suffering-from-heart-disease-and-heart-attack-vector.jpg",
        steps: [
            { text: "Call emergency services immediately.", image: "https://via.placeholder.com/300x200?text=Heart+Attack+Step+1" },
            { text: "Help the person stay calm and sit down.", image: "https://via.placeholder.com/300x200?text=Heart+Attack+Step+2" },
            { text: "Give them aspirin (unless allergic).", image: "https://via.placeholder.com/300x200?text=Heart+Attack+Step+3" },
            { text: "Perform CPR if they become unconscious.", image: "https://via.placeholder.com/300x200?text=Heart+Attack+Step+4" }
        ]
    },
    {
        title: "Bleeding Control",
        cardImage: "https://media.istockphoto.com/id/477827854/vector/first-aid-compression-injury-in-the-arm.jpg?s=612x612&w=0&k=20&c=8EleDCRXbTyk6ijokYwiZHvDapULuVJDJhGpnTFl3MM=",
        steps: [
            { text: "Apply direct pressure with a clean cloth to stop bleeding.", image: "https://via.placeholder.com/300x200?text=Bleeding+Step+1" },
            { text: "Keep the injured part elevated if possible.", image: "https://via.placeholder.com/300x200?text=Bleeding+Step+2" },
            { text: "Avoid removing deeply embedded objects.", image: "https://via.placeholder.com/300x200?text=Bleeding+Step+3" },
            { text: "Seek medical help if bleeding does not stop.", image: "https://via.placeholder.com/300x200?text=Bleeding+Step+4" }
        ]
    },
    {
        title: "Fractures",
        cardImage: "https://media.istockphoto.com/id/1286300531/vector/bone-fracture-trauma-to-the-body-crack-and-splinters.jpg?s=612x612&w=0&k=20&c=Qbkeyjf92nsBA9rKGpJsjejDxW5w7MgMjWcB_rgA4Lk=",
        steps: [
            { text: "Immobilize the injured limb with a splint or cloth.", image: "https://via.placeholder.com/300x200?text=Fracture+Step+1" },
            { text: "Do not try to realign the bone.", image: "https://via.placeholder.com/300x200?text=Fracture+Step+2" },
            { text: "Apply a cold pack to reduce swelling.", image: "https://via.placeholder.com/300x200?text=Fracture+Step+3" },
            { text: "Seek medical help immediately.", image: "https://via.placeholder.com/300x200?text=Fracture+Step+4" }
        ]
    }
];
const grid = document.getElementById("emergencyGrid");
const modal = document.getElementById("modal");
const overlay = document.getElementById("overlay");
const modalTitle = document.getElementById("modalTitle");
const modalImage = document.getElementById("modalImage");
const modalStep = document.getElementById("modalStep");
const prevStep = document.getElementById("prevStep");
const nextStep = document.getElementById("nextStep");
const closeModal = document.getElementById("closeModal");

let currentStep = 0, selectedEmergency = null;

emergencies.forEach((emergency) => {
    const card = document.createElement("div");
    card.classList.add("card");
    card.innerHTML = `<h2>${emergency.title}</h2><img src="${emergency.cardImage}" class="gif">`;
    card.addEventListener("click", () => {
        selectedEmergency = emergency;
        currentStep = 0;
        modalTitle.innerText = emergency.title;
        modalImage.src = emergency.steps[currentStep].image;
        modalStep.innerText = emergency.steps[currentStep].text;
        modal.style.display = overlay.style.display = "block";
    });
    grid.appendChild(card);
});

nextStep.onclick = () => { if (++currentStep < selectedEmergency.steps.length) { modalImage.src = selectedEmergency.steps[currentStep].image; modalStep.innerText = selectedEmergency.steps[currentStep].text; }};
prevStep.onclick = () => { if (--currentStep >= 0) { modalImage.src = selectedEmergency.steps[currentStep].image; modalStep.innerText = selectedEmergency.steps[currentStep].text; }};
closeModal.onclick = overlay.onclick = () => { modal.style.display = overlay.style.display = "none"; };
