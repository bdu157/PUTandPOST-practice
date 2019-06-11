//
//  ToDoListTableViewController.swift
//  PUTandPost-practice
//
//  Created by Dongwoo Pae on 6/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
        // MARK: - Properties
        
        private let todoController = TodoController()
        let pushMethod: PushMethod = .put
    
    @IBOutlet weak var textField: UITextField!

    
        override func viewDidLoad() {
            super.viewDidLoad()
            fetchTodos()
        }
        
        // MARK: - Table view data source
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoController.todos.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
            
            // Get appropriate todo from datasource and configure cell
            let todo = self.todoController.todos[indexPath.row]
            cell.textLabel?.text = todo.title
            return cell
        }
        
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let todo = todoController.todos[indexPath.row]
            // configure swipe action
            let title: String
            switch self.pushMethod {
            case .put:
                title = "PUT Again"
            case .post:
                title = "POST Again"
            }
            let againAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
                self.todoController.push(todo: todo, using: self.pushMethod, completion: { (error) in
                    if let error = error {
                        print("Error pushing todo to server again:\(error)")
                        handler(false)
                    }
                    self.fetchTodos()
                    handler(true)
                })
            }
            DispatchQueue.main.async {
                againAction.backgroundColor = .red
            }
            return UISwipeActionsConfiguration(actions: [againAction])
        }
    
    
        @IBAction func saveButtonTapped(_ sender: Any) {
            // get todo text from textfield
            guard let title = self.textField.text else {return}
            
            // create todo
            let todo = todoController.createTodo(with: title)
        
            // Send todo to Firebase
            todoController.push(todo: todo, using: self.pushMethod) { (error) in
                if let error = error {
                    NSLog("there is an error: \(error)")
                    return
                }
                
                self.fetchTodos()
                
                }
            }
    
        
        func fetchTodos() {
            // fetch todos from Firebase and display them
            self.todoController.fetchTodos { (error) in
                if let error = error {
                    NSLog("there is an error: \(error)")
                    //show an alert view or some other UI control to show error state
                    return
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()  //recalls tableview datasource methods - cellforrowat and others.....
                    }
            }
        }
    }

