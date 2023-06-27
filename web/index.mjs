const appEl = document.getElementById("app");

const prefersReducedMotion = window.matchMedia(
  "(prefers-reduced-motion: reduce)"
).matches;

function showHomeScreen(skipTransition = false) {
  const change = () => {
    const homeScreenTemplate = document.getElementById("home");
    appEl.innerHTML = homeScreenTemplate.innerHTML;
    initializeArticleGroups();
  };

  if (
    document.startViewTransition &&
    !skipTransition &&
    !prefersReducedMotion
  ) {
    document.startViewTransition(change);
  } else {
    change();
  }
}

function showArticle(id) {
  const change = () => {
    const articleTemplate = document.querySelector(
      `template[data-article-id="${id}"]`
    );
    appEl.innerHTML = articleTemplate.innerHTML;
    document.documentElement.addEventListener("click", (e) => {
      if ("back" in e.target.dataset) showHomeScreen();
    });
  };

  if (document.startViewTransition && !prefersReducedMotion) {
    document.startViewTransition(change);
  } else {
    change();
  }
}

function initializeArticleGroups() {
  const articleGroups = document.getElementsByClassName(
    "article-preview-group"
  );
  for (const articleGroup of articleGroups) {
    const onClick = (e) => {
      if (e.target === e.currentTarget) return;
      const article = e.target.closest("[data-show-article]");
      const id = article.dataset.showArticle;
      showArticle(id);
    };
    articleGroup.addEventListener("click", onClick, { capture: true });
  }
}

showHomeScreen(true);
