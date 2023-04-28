[toc]

## ER可视化

```python


def plot_histograms(classifiers=True, beta=0.5, n_classes=3, verbose=1):
    """
    Loads different estimators from `grid` folder and calculate some statistics to plot histograms.
    Params:
        classifiers (bool): if `True`, this will plot classifiers, regressors otherwise.
        beta (float): beta value for calculating fbeta score for various estimators.
        n_classes (int): number of classes
    """
    # get the estimators from the performed grid search result
    estimators = best_estimators(classifiers)

    final_result = {}
    for estimator, params, cv_score in estimators:
        final_result[estimator.__class__.__name__] = []
        for i in range(3):
            result = {}
            # initialize the class
            er = EmotionRecognizer(estimator, verbose=0)
            # load the data
            er.load_data()
            if i == 0:
                # first get 1% of sample data
                sample_size = 0.01
            elif i == 1:
                # second get 10% of sample data
                sample_size = 0.1
            elif i == 2:
                # last get all the data
                sample_size = 1
            # calculate number of training and testing samples
            n_train_samples = int(len(er.X_train) * sample_size)
            n_test_samples = int(len(er.X_test) * sample_size)
            # set the data
            er.X_train = er.X_train[:n_train_samples]
            er.X_test = er.X_test[:n_test_samples]
            er.y_train = er.y_train[:n_train_samples]
            er.y_test = er.y_test[:n_test_samples]
            # calculate train time
            t_train = time()
            er.train()
            t_train = time() - t_train
            # calculate test time
            t_test = time()
            test_accuracy = er.test_score()
            t_test = time() - t_test
            # set the result to the dictionary
            result["train_time"] = t_train
            result["pred_time"] = t_test
            result["acc_train"] = cv_score
            result["acc_test"] = test_accuracy
            result["f_train"] = er.train_fbeta_score(beta)
            result["f_test"] = er.test_fbeta_score(beta)
            if verbose:
                print(
                    f"[+] {estimator.__class__.__name__} with {sample_size * 100}% ({n_train_samples}) data samples achieved {cv_score * 100:.3f}% Validation Score in {t_train:.3f}s & {test_accuracy * 100:.3f}% Test Score in {t_test:.3f}s"
                )
            # append the dictionary to the list of results
            final_result[estimator.__class__.__name__].append(result)
        if verbose:
            print()
    visualize(final_result, n_classes=n_classes)


def visualize(results, n_classes):
    """
    Visualization code to display results of various learners.

    inputs:
      - results: a dictionary of lists of dictionaries that contain various results on the corresponding estimator
      - n_classes: number of classes
    """

    n_estimators = len(results)

    # naive predictor
    accuracy = 1 / n_classes
    f1 = 1 / n_classes
    # Create figure
    fig, ax = pl.subplots(2, 4, figsize=(11, 7))
    # Constants
    bar_width = 0.4
    colors = [
        (random.random(), random.random(), random.random()) for _ in range(n_estimators)
    ]
    # Super loop to plot four panels of data
    for k, learner in enumerate(results.keys()):
        for j, metric in enumerate(
                ["train_time", "acc_train", "f_train", "pred_time", "acc_test", "f_test"]
        ):
            for i in np.arange(3):
                x = bar_width * n_estimators
                # Creative plot code
                ax[j // 3, j % 3].bar(
                    i * x + k * (bar_width),
                    results[learner][i][metric],
                    width=bar_width,
                    color=colors[k],
                )
                ax[j // 3, j % 3].set_xticks([x - 0.2, x * 2 - 0.2, x * 3 - 0.2])
                ax[j // 3, j % 3].set_xticklabels(["1%", "10%", "100%"])
                ax[j // 3, j % 3].set_xlabel("Training Set Size")
                ax[j // 3, j % 3].set_xlim((-0.2, x * 3))
    # Add unique y-labels
    ax[0, 0].set_ylabel("Time (in seconds)")
    ax[0, 1].set_ylabel("Accuracy Score")
    ax[0, 2].set_ylabel("F-score")
    ax[1, 0].set_ylabel("Time (in seconds)")
    ax[1, 1].set_ylabel("Accuracy Score")
    ax[1, 2].set_ylabel("F-score")
    # Add titles
    ax[0, 0].set_title("Model Training")
    ax[0, 1].set_title("Accuracy Score on Training Subset")
    ax[0, 2].set_title("F-score on Training Subset")
    ax[1, 0].set_title("Model Predicting")
    ax[1, 1].set_title("Accuracy Score on Testing Set")
    ax[1, 2].set_title("F-score on Testing Set")
    # Add horizontal lines for naive predictors
    ax[0, 1].axhline(
        y=accuracy, xmin=-0.1, xmax=3.0, linewidth=1, color="k", linestyle="dashed"
    )
    ax[1, 1].axhline(
        y=accuracy, xmin=-0.1, xmax=3.0, linewidth=1, color="k", linestyle="dashed"
    )
    ax[0, 2].axhline(
        y=f1, xmin=-0.1, xmax=3.0, linewidth=1, color="k", linestyle="dashed"
    )
    ax[1, 2].axhline(
        y=f1, xmin=-0.1, xmax=3.0, linewidth=1, color="k", linestyle="dashed"
    )
    # Set y-limits for score panels
    ax[0, 1].set_ylim((0, 1))
    ax[0, 2].set_ylim((0, 1))
    ax[1, 1].set_ylim((0, 1))
    ax[1, 2].set_ylim((0, 1))
    # Set additional plots invisibles
    ax[0, 3].set_visible(False)
    ax[1, 3].axis("off")
    # Create legend
    for i, learner in enumerate(results.keys()):
        pl.bar(0, 0, color=colors[i], label=learner)
    pl.legend()
    # Aesthetics
    pl.suptitle(
        "Performance Metrics for Three Supervised Learning Models", fontsize=16, y=1.10
    )
    pl.tight_layout()
    pl.show()
```

## 创建meta

- ```python
  
  def create_meta_csv(
      train_meta_files,
      test_meta_files,
      dbs=None,
      e_config=None,
      verbose=1,
      override_csv=False,
  ):
      """
      @deprecated
      Write available CSV files in `self.train_desc_files` and `self.test_desc_files`
      determined by `self._set_metadata_filenames()` method.
  
      ## Note:
      硬编码实现:
      if emodb in train_csv_file:
              write_emodb_csv(
                  self.e_config,
                  train_name=train_csv_file,
                  test_name=test_csv_file,
                  verbose=self.verbose,
              )
              if self.verbose:
                  print("[I] Generated EMO-DB  CSV meta File")
          elif ravdess in train_csv_file:
              write_ravdess_csv(
                  self.e_config,
                  train_name=train_csv_file,
                  test_name=test_csv_file,
                  verbose=self.verbose,
              )
              if self.verbose:
                  print("[I] Generated RAVDESS CSV meta File")
      """
      meta_handler_dict = {emodb: create_emodb_csv, ravdess: create_ravdess_csv}
      for train_csv_file, test_csv_file in zip(train_meta_files, test_meta_files):
          # 兼容性的写法
          if os.path.isfile(train_csv_file) and os.path.isfile(test_csv_file):
              # file already exists, just skip writing csv files
              if not override_csv:
                  continue
          if dbs:
              for db in dbs:
                  if meta_handler_dict.get(db) is None:
                      raise ValueError(f"{db} not recognized")
                  meta_handler_dict[db](
                      e_config,
                      train_name=train_csv_file,
                      test_name=test_csv_file,
                      verbose=verbose,
                  )
                  if verbose:
                      print(f"[I] Generated {db} CSV meta File")
  
  ```

  

- ```
   counter += 1
          if event in (sg.WINDOW_CLOSED, "Exit"):
              break
          if event == "-DEMO LIST-":  # if double clicked (used the bind return key parm)
              if sg.user_settings_get_entry("-dclick runs-"):
                  event = "Run"
              elif sg.user_settings_get_entry("-dclick edits-"):
                  event = "Edit"
          if event == "Edit":
              editor_program = get_editor()
              for file in values["-DEMO LIST-"]:
                  if find_in_file.file_list_dict is not None:
                      full_filename, line = window_choose_line_to_edit(
                          file,
                          find_in_file.file_list_dict[file][0],
                          find_in_file.file_list_dict[file][1],
                          find_in_file.file_list_dict[file][2],
                      )
                  else:
                      full_filename, line = get_file_list_dict()[file], 1
                  if line is not None:
                      sg.cprint(
                          f"Editing using {editor_program}", c="white on red", end=""
                      )
                      sg.cprint("")
                      sg.cprint(f"{full_filename}", c="white on purple")
                      # if line != 1:
                      if using_local_editor():
                          sg.execute_command_subprocess(
                              editor_program, f'"{full_filename}"'
                          )
                      else:
                          try:
                              sg.execute_editor(full_filename, line_number=int(line))
                          except:
                              sg.execute_command_subprocess(
                                  editor_program, f'"{full_filename}"'
                              )
                      # else:
                      #     sg.execute_editor(full_filename)
                  else:
                      sg.cprint("Editing canceled")
          elif event == "Run":
              sg.cprint("Running....", c="white on green", end="")
              sg.cprint("")
              for file in values["-DEMO LIST-"]:
                  file_to_run = str(file_list_dict[file])
                  sg.cprint(file_to_run, text_color="white", background_color="purple")
                  try:
                      sp = sg.execute_py_file(file_to_run, pipe_output=values["-WAIT-"])
                  except Exception as e:
                      sg.cprint(
                          f"Error trying to run python file.  Error info:",
                          e,
                          c="white on red",
                      )
                  try:
                      if values["-WAIT-"]:
                          sg.cprint(
                              f"Waiting on results..",
                              text_color="white",
                              background_color="red",
                              end="",
                          )
                          while True:
                              results = sg.execute_get_results(sp)
                              sg.cprint(
                                  f"STDOUT:", text_color="white", background_color="green"
                              )
                              sg.cprint(results[0])
                              sg.cprint(
                                  f"STDERR:", text_color="white", background_color="green"
                              )
                              sg.cprint(results[1])
                              if not sg.execute_subprocess_still_running(sp):
                                  break
                  except AttributeError:
                      sg.cprint(
                          'Your version of PySimpleGUI needs to be upgraded to fully use the "WAIT" feature.',
                          c="white on red",
                      )
          elif event.startswith("Edit Me"):
              editor_program = get_editor()
              sg.cprint(f"opening using {editor_program}:")
              sg.cprint(f"{__file__}", text_color="white", background_color="red", end="")
              sg.execute_command_subprocess(f"{editor_program}", f'"{__file__}"')
          elif event == "-FILTER-":
              new_list = [i for i in file_list if values["-FILTER-"].lower() in i.lower()]
              window["-DEMO LIST-"].update(new_list)
              window["-FILTER NUMBER-"].update(f"{len(new_list)} files")
              window["-FIND NUMBER-"].update("")
              window["-FIND-"].update("")
              window["-FIND RE-"].update("")
          elif event == "-FOCUS FIND-":
              window["-FIND-"].set_focus()
          elif event == "-FOCUS FILTER-":
              window["-FILTER-"].set_focus()
          elif event == "-FOCUS RE FIND-":
              window["-FIND RE-"].set_focus()
          elif (
              event == "-FIND-"
              or event == "-FIRST MATCH ONLY-"
              or event == "-VERBOSE-"
              or event == "-FIND RE-"
          ):
              is_ignore_case = values["-IGNORE CASE-"]
              old_ignore_case = False
              current_typed_value = str(values["-FIND-"])
              if len(values["-FIND-"]) == 1:
                  window[ML_KEY].update("")
                  window["-VERBOSE-"].update(False)
                  values["-VERBOSE-"] = False
              if values["-VERBOSE-"]:
                  window[ML_KEY].update("")
              if values["-FIND-"]:
                  if (
                      find_in_file.file_list_dict is None
                      or old_typed_value is None
                      or old_ignore_case is not is_ignore_case
                  ):
                      # New search.
                      old_typed_value = current_typed_value
                      file_list = find_in_file(
                          values["-FIND-"],
                          get_file_list_dict(),
                          verbose=values["-VERBOSE-"],
                          window=window,
                          ignore_case=is_ignore_case,
                          show_first_match=values["-FIRST MATCH ONLY-"],
                      )
                  elif (
                      current_typed_value.startswith(old_typed_value)
                      and old_ignore_case is is_ignore_case
                  ):
                      old_typed_value = current_typed_value
                      file_list = find_in_file(
                          values["-FIND-"],
                          find_in_file.file_list_dict,
                          verbose=values["-VERBOSE-"],
                          window=window,
                          ignore_case=is_ignore_case,
                          show_first_match=values["-FIRST MATCH ONLY-"],
                      )
                  else:
                      old_typed_value = current_typed_value
                      file_list = find_in_file(
                          values["-FIND-"],
                          get_file_list_dict(),
                          verbose=values["-VERBOSE-"],
                          window=window,
                          ignore_case=is_ignore_case,
                          show_first_match=values["-FIRST MATCH ONLY-"],
                      )
                  window["-DEMO LIST-"].update(sorted(file_list))
                  window["-FIND NUMBER-"].update(f"{len(file_list)} files")
                  window["-FILTER NUMBER-"].update("")
                  window["-FIND RE-"].update("")
                  window["-FILTER-"].update("")
              elif values["-FIND RE-"]:
                  window["-ML-"].update("")
                  file_list = find_in_file(
                      values["-FIND RE-"],
                      get_file_list_dict(),
                      regex=True,
                      verbose=values["-VERBOSE-"],
                      window=window,
                  )
                  window["-DEMO LIST-"].update(sorted(file_list))
                  window["-FIND NUMBER-"].update(f"{len(file_list)} files")
                  window["-FILTER NUMBER-"].update("")
                  window["-FIND-"].update("")
                  window["-FILTER-"].update("")
          elif event == "Find RE":
              window["-ML-"].update("")
              file_list = find_in_file(
                  values["-FIND RE-"],
                  get_file_list_dict(),
                  regex=True,
                  verbose=values["-VERBOSE-"],
                  window=window,
              )
              window["-DEMO LIST-"].update(sorted(file_list))
              window["-FIND NUMBER-"].update(f"{len(file_list)} files")
              window["-FILTER NUMBER-"].update("")
              window["-FIND-"].update("")
              window["-FILTER-"].update("")
              sg.cprint("Regular expression find completed")
          elif event == "Settings":
              if settings_window() is True:
                  window.close()
                  window = make_window()
                  file_list_dict = get_file_list_dict()
                  file_list = get_file_list()
                  window["-FILTER NUMBER-"].update(f"{len(file_list)} files")
          elif event == "Clear":
              file_list = get_file_list()
              window["-FILTER-"].update("")
              window["-FILTER NUMBER-"].update(f"{len(file_list)} files")
              window["-FIND-"].update("")
              window["-DEMO LIST-"].update(file_list)
              window["-FIND NUMBER-"].update("")
              window["-FIND RE-"].update("")
              window["-ML-"].update("")
          elif event == "-FOLDERNAME-":
              sg.user_settings_set_entry("-demos folder-", values["-FOLDERNAME-"])
              file_list_dict = get_file_list_dict()
              file_list = get_file_list()
              window["-DEMO LIST-"].update(values=file_list)
              window["-FILTER NUMBER-"].update(f"{len(file_list)} files")
              window["-ML-"].update("")
              window["-FIND NUMBER-"].update("")
              window["-FIND-"].update("")
              window["-FIND RE-"].update("")
              window["-FILTER-"].update("")
          elif event == "Open Folder":
              explorer_program = get_explorer()
              if explorer_program:
                  sg.cprint(
                      f"Opening Folder using {explorer_program}...",
                      c="white on green",
                      end="",
                  )
                  sg.cprint("")
                  for file in values["-DEMO LIST-"]:
                      file_selected = str(file_list_dict[file])
                      file_path = os.path.dirname(file_selected)
                      if sg.running_windows():
                          file_path = file_path.replace("/", "\\")
                      sg.cprint(file_path, text_color="white", background_color="purple")
                      sg.execute_command_subprocess(explorer_program, file_path)
          elif event == "Copy Path":
              for file in values["-DEMO LIST-"]:
                  sg.cprint("Copying the last highlighted filename in your list")
                  if find_in_file.file_list_dict is not None:
                      full_filename, line = window_choose_line_to_edit(
                          file,
                          find_in_file.file_list_dict[file][0],
                          find_in_file.file_list_dict[file][1],
                          find_in_file.file_list_dict[file][2],
                      )
                  else:
                      full_filename, line = get_file_list_dict()[file], 1
                  if line is not None:
                      sg.cprint(
                          f"Added to Clipboard Full Path {full_filename}",
                          c="white on purple",
                      )
                      sg.clipboard_set(full_filename)
          elif event == "Version":
              sg.popup_scrolled(sg.get_versions(), keep_on_top=True, non_blocking=True)
          elif event == "-SHOW ALL FILES-":
              python_only = not values[event]
              file_list_dict = get_file_list_dict()
              file_list = get_file_list()
              window["-DEMO LIST-"].update(values=file_list)
              window["-FILTER NUMBER-"].update(f"{len(file_list)} files")
              window["-ML-"].update("")
              window["-FIND NUMBER-"].update("")
              window["-FIND-"].update("")
              window["-FIND RE-"].update("")
              window["-FILTER-"].update("")
  ```

  

