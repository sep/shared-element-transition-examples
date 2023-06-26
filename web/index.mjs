const appEl = document.getElementById("app");

function showHomeScreen() {
  const change = () => {
    const homeScreenTemplate = document.getElementById("home");
    appEl.innerHTML = homeScreenTemplate.innerHTML;
    initializeArticleGroups();
  };

  if (document.startViewTransition) {
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

  if (document.startViewTransition) {
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
      const id = e.target.dataset.showArticle;
      if (typeof id === "undefined") return;
      showArticle(id);
    };
    articleGroup.addEventListener("click", onClick);
  }
}

showHomeScreen();
